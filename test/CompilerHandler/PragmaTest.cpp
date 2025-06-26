#pragma tensorium target(avx2)

#ifdef TENSORIUM_TARGET_avx2
int main() { return 42; }
#else
int main() { return 0; }
#endif
