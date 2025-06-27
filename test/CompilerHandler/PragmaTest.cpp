#pragma tensorium target(cpu)
void foo() {}

void bar() {}

int main() { 
#pragma tensorium target(cpu)
	bar();
	return 0; 
}
