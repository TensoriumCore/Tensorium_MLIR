#pragma once

#include <cctype>
#include <string>
#include <unordered_map>
#include <vector>

enum TokenType {
  plus,
  minus,
  mult,
  divide,
  pow,
  equal,
  lpar,
  rpar,
  lbrace,
  rbrace,
  symbol,
  integer,
  real,
  derivative,
  partial,
  integral,
  covariant,
  contravariant,
  transpose,
  inner,
  outer,
  end,
  tilde,
  hat,
  overbar,
  bar,
  decorator,
  unknown
};

enum class GreekSymbolminus {
  alpha,
  beta,
  gamma,
  delta,
  epsilon,
  zeta,
  eta,
  theta,
  iota,
  kappa,
  lambda,
  mu,
  nu,
  xi,
  omicron,
  pi,
  rho,
  sigma,
  tau,
  upsilon,
  phi,
  chi,
  psi,
  omega
};

enum class GreekSymbolplus {
  Alpha,
  Beta,
  Gamma,
  Delta,
  Epsilon,
  Zeta,
  Eta,
  Theta,
  Iota,
  Kappa,
  Lambda,
  Mu,
  Nu,
  Xi,
  Omicron,
  Pi,
  Rho,
  Sigma,
  Tau,
  Upsilon,
  Phi,
  Chi,
  Psi,
  Omega
};

struct Token {
  TokenType type;
  GreekSymbolminus greek_minus = GreekSymbolminus::alpha;
  GreekSymbolplus greek_plus = GreekSymbolplus::Alpha;
  std::string value;

  Token(TokenType t, const std::string &val) : type(t), value(val) {}

  Token(TokenType t, GreekSymbolminus g, GreekSymbolplus G,
        const std::string &val)
      : type(t), greek_minus(g), greek_plus(G), value(val) {}
};

class Lexer {
public:
  explicit Lexer(const std::string &input) : input(input), pos(0) {}

  std::vector<Token> tokenize() {
    std::vector<Token> tokens;

    while (!eof()) {
      skipWhitespace();
      if (eof())
        break;
      if (input.compare(pos, 2, "\\,") == 0 ||
          input.compare(pos, 2, "\\ ") == 0) {
        pos += 2;
        continue;
      }

      char c = peek();

      if (std::isdigit(c)) {
        tokens.push_back(parseNumber());
        continue;
      }

      if (peek() == '\\') {
        Token t = parseCommandOrSymbol();
        tokens.push_back(t);
        continue;
      }

      if (c == 'd') {
        std::string s(1, get());
        if (peek() == '\\') {
          get(); 
          std::string cmd;
          while (!eof() && std::isalpha(peek()))
            cmd += get();
          s += "\\" + cmd;
        } else {
          while (!eof() && std::isalpha(peek()))
            s += get();
        }
        tokens.emplace_back(TokenType::symbol, s);
        continue;
      }
      if (c == 'd') {
        std::string s(1, get());
        if (peek() == '\\') {
          get();
          std::string cmd;
          while (!eof() && std::isalpha(peek()))
            cmd += get();
          s += "\\" + cmd;
        }
        tokens.emplace_back(TokenType::symbol, s);
        continue;
      }

	  if (std::isalpha(c)) {
		  std::string s;
		  while (!eof() && std::isalnum(peek()))
			  s += get();
		  tokens.emplace_back(TokenType::symbol, s);
		  continue;
	  }

	  if (c == '^') {
		  get(); 
		  while (!eof() && std::isspace(peek()))
			  get();
		  char next = peek(); 
		  if (std::isdigit(next) || next == '{' || next == '(') {
			  tokens.emplace_back(TokenType::pow, "^");
		  } else {
			  tokens.emplace_back(TokenType::contravariant, "^");
		  }
		  continue;
	  }

	  std::string s(1, get());
	  auto it = SyntaxTable.find(s);
	  tokens.emplace_back(
			  it != SyntaxTable.end() ? it->second : TokenType::unknown, s);
	}

	tokens.emplace_back(TokenType::end, "");
	return tokens;
  }

private:
  std::string input;
  size_t pos;

  char peek() const { return pos < input.size() ? input[pos] : '\0'; }

  char get() { return pos < input.size() ? input[pos++] : '\0'; }

  bool eof() const { return pos >= input.size(); }

  void skipWhitespace() {
    while (!eof() && std::isspace(peek()))
      get();
  }

  bool is_decorator(TokenType type) {
    return type == TokenType::tilde || type == TokenType::hat ||
           type == TokenType::bar;
  }

  Token parseNumber() {
    std::string num;
    bool has_dot = false;

    while (!eof() && (std::isdigit(peek()) || peek() == '.')) {
      if (peek() == '.')
        has_dot = true;
      num += get();
    }

    return {has_dot ? TokenType::real : TokenType::integer, num};
  }

  Token parseCommandOrSymbol() {
    std::string s;
    s += get();
    while (!eof() && std::isalpha(peek()))
      s += get();

    if (s == "\\tilde" || s == "\\hat" || s == "\\bar")
      return Token(TokenType::decorator, s);

    if (s == "\\partial")
      return Token(TokenType::partial, s);
    if (s == "\\int")
      return Token(TokenType::integral, s);

    if (auto it = SyntaxTable.find(s); it != SyntaxTable.end())
      return Token(it->second, s);

    if (auto it = GreekMapLower.find(s); it != GreekMapLower.end())
      return Token(TokenType::symbol, it->second, GreekSymbolplus::Alpha, s);
    if (auto it = GreekMapUpper.find(s); it != GreekMapUpper.end())
      return Token(TokenType::symbol, GreekSymbolminus::alpha, it->second, s);

    return Token(TokenType::symbol, s);
  }

private:
  inline static const std::unordered_map<std::string, TokenType> SyntaxTable = {
      {"+", TokenType::plus},           {"-", TokenType::minus},
      {"=", TokenType::equal},          {"\\otimes", TokenType::outer},
      {"\\overline", TokenType::bar},   {"\\overbar", TokenType::bar},
      {"*", TokenType::mult},           {"/", TokenType::divide},
      {"**", TokenType::pow},           {"(", TokenType::lpar},
      {")", TokenType::rpar},           {"{", TokenType::lbrace},
      {"}", TokenType::rbrace},         {"d", TokenType::derivative},
      {"\\end", TokenType::end},        {"\\begin", TokenType::end},
      {"\\left", TokenType::end},       {"\\right", TokenType::end},
      {"\\text", TokenType::symbol},    {"\\mathrm", TokenType::symbol},
      {"\\mathcal", TokenType::symbol}, {"\\partial", TokenType::partial},
      {"\\int", TokenType::integral},   {"_", TokenType::covariant},
      {"^", TokenType::contravariant},  {"T", TokenType::transpose},
      {"\\cdot", TokenType::inner},
  };

  inline static const std::unordered_map<std::string, GreekSymbolminus>
      GreekMapLower = {{"\\alpha", GreekSymbolminus::alpha},
                       {"\\beta", GreekSymbolminus::beta},
                       {"\\gamma", GreekSymbolminus::gamma},
                       {"\\delta", GreekSymbolminus::delta},
                       {"\\epsilon", GreekSymbolminus::epsilon},
                       {"\\zeta", GreekSymbolminus::zeta},
                       {"\\eta", GreekSymbolminus::eta},
                       {"\\theta", GreekSymbolminus::theta},
                       {"\\iota", GreekSymbolminus::iota},
                       {"\\kappa", GreekSymbolminus::kappa},
                       {"\\lambda", GreekSymbolminus::lambda},
                       {"\\mu", GreekSymbolminus::mu},
                       {"\\nu", GreekSymbolminus::nu},
                       {"\\xi", GreekSymbolminus::xi},
                       {"\\omicron", GreekSymbolminus::omicron},
                       {"\\pi", GreekSymbolminus::pi},
                       {"\\rho", GreekSymbolminus::rho},
                       {"\\sigma", GreekSymbolminus::sigma},
                       {"\\tau", GreekSymbolminus::tau},
                       {"\\upsilon", GreekSymbolminus::upsilon},
                       {"\\phi", GreekSymbolminus::phi},
                       {"\\chi", GreekSymbolminus::chi},
                       {"\\psi", GreekSymbolminus::psi},
                       {"\\omega", GreekSymbolminus::omega}};

  inline static const std::unordered_map<std::string, GreekSymbolplus>
      GreekMapUpper = {{"\\Alpha", GreekSymbolplus::Alpha},
                       {"\\Beta", GreekSymbolplus::Beta},
                       {"\\Gamma", GreekSymbolplus::Gamma},
                       {"\\Delta", GreekSymbolplus::Delta},
                       {"\\Epsilon", GreekSymbolplus::Epsilon},
                       {"\\Zeta", GreekSymbolplus::Zeta},
                       {"\\Eta", GreekSymbolplus::Eta},
                       {"\\Theta", GreekSymbolplus::Theta},
                       {"\\Iota", GreekSymbolplus::Iota},
                       {"\\Kappa", GreekSymbolplus::Kappa},
                       {"\\Lambda", GreekSymbolplus::Lambda},
                       {"\\Mu", GreekSymbolplus::Mu},
                       {"\\Nu", GreekSymbolplus::Nu},
                       {"\\Xi", GreekSymbolplus::Xi},
                       {"\\Omicron", GreekSymbolplus::Omicron},
                       {"\\Pi", GreekSymbolplus::Pi},
                       {"\\Rho", GreekSymbolplus::Rho},
                       {"\\Sigma", GreekSymbolplus::Sigma},
                       {"\\Tau", GreekSymbolplus::Tau},
                       {"\\Upsilon", GreekSymbolplus::Upsilon},
                       {"\\Phi", GreekSymbolplus::Phi},
                       {"\\Chi", GreekSymbolplus::Chi},
                       {"\\Psi", GreekSymbolplus::Psi},
                       {"\\Omega", GreekSymbolplus::Omega}};
};

std::string token_type_name(TokenType type);
