assert() {
  input=$1
  expected=$2

  echo "$input" | ./occ > tmp.s
  gcc -o tmp tmp.s
  ./tmp
  actual=$?

  if [ "$expected" = "$actual" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

assert "int main() { return 7; }" "7"
assert "int main() { return 42; }" "42"
assert "int main() { return 123; }" "123"
assert "int main() { return 2+3; }" "5"
assert "int main() { return 2  +3; }" "5"
assert "int main() { return   2 +  3; }" "5"
assert "int main() { return 2+13; }" "15"
assert "int main() { return 3+14 +3 +4; }" "24"
assert "int main() { return 8-5; }" "3"
assert "int main() { return 8-5-1; }" "2"
assert "int main() { return 2+3-1; }" "4"
assert "int main() { return 4+6+1-2+12-5-2+5; }" "19"
assert "int main() { return 2*4; }" "8"
assert "int main() { return 1+2*4; }" "9"
assert "int main() { return 2*4+1; }" "9"
assert "int main() { return 4/2; }" "2"
assert "int main() { return 1+4/2; }" "3"
assert "int main() { return 4/2+1; }" "3"
assert "int main() { return 4/2+2*6/3; }" "6"
assert "int main() { return 1+2*3; }" "7"
assert "int main() { return (1+2)*3; }" "9"
assert "int main() { 2; return 3; }" "3"
assert "int main() { 2; 3; return 5+4/2; }" "7"
assert "int main() { return 1; 2; 3; }" "1"
assert "int main() { 1; return 2; 3; }" "2"
assert "int main() { 1; 2; return 3; }" "3"
assert "int main() { int a=12; return a; }" "12"
assert "int main() { int a=12; a=13; return a; }" "13"
assert "int main() { int var=14; return var; }" "14"
assert "int main() { int a=12; int b=13; return a; }" "12"
assert "int main() { int a=12; int b=13; return b; }" "13"
assert "int main() { int var=14; int foo=15; int bar=16; return var; }" "14"
assert "int main() { int var=14; int foo=15; int bar=16; return foo; }" "15"
assert "int main() { int var=14; int foo=15; int bar=16; return bar; }" "16"
assert "int main() { int a=42; int var=14; int foo=15; int bar=16; return a; }" "42"
assert "int main() { int a=42; int var=14; int foo=15; int bar=16; return bar; }" "16"
assert "int main() { int a=42; a++; return a; }" "43"
assert "int main() { int a=42; a--; return a; }" "41"
assert "int main() { int a=1; int b=2; a=b=42; return a; }" "42"
assert "int main() { int a=1; int b=2; a=b=42; return b; }" "42"
assert "int main() { int a=1; int b=2; a=b=42; a++; return a; }" "43"
assert "int main() { int a=1; int b=2; a=b=42; a++; return b; }" "42"
assert "int ret42() { return 42; } int main() { return ret42(); }" "42"
assert "int ret42() { return 42; } int main() { int res = ret42(); return res; }" "42"
assert "int ret42() { return 42; } int main() { int res = ret42(); res++; return res; }" "43"
assert "int func() { int a=12; return 42; } int main() { int a=func(); return a; }" "42"
assert "int main() { int a=12; return sizeof(a); }" "4"
assert "int main() { int a=12; int b=sizeof(a); return b; }" "4"
assert "int main() { return sizeof(int); }" "4"
assert "int main() { return sizeof(int*); }" "8"
assert "int main() { int a=23; int *p=&a; return *p; }" "23"
assert "int main() { int a=23; int *p=&a; *p=42; return a; }" "42"
assert "int main() { int a=23; int *p=&a; *p=42; return *p; }" "42"
assert "int main() { int a=23; int *p=&a; int b=*p; return b; }" "23"
assert "int main() { int a=12; int b=23; int *p=&a; p=p+1; return *p; }" "23"
assert "int main() { int a=12; int b=23; int *p=&b; p=p-1; return *p; }" "12"
assert "int main() { int a=12; int b=23; int *p=&a; p++; return *p; }" "23"
assert "int main() { int a=12; int b=23; int *p=&a; return *(p+1); }" "23"
assert "int main() { int a=12; int b=23; int *p=&b; p--; return *p; }" "12"
assert "int main() { int a=12; int *p=&a; *p=42; return a; }" "42"
assert "int main() { int a=12; int b=23; int *p=&a; p++; *p=42; return a; }" "12"
assert "int main() { int a=12; int b=23; int *p=&a; p++; *p=42; return b; }" "42"
assert "int ret(int x) { return x; } int main() { int n=ret(12); return n; }" "12"
assert "int ret(int x) { return x; } int main() { return ret(23); }" "23"
assert "int add(int x, int y) { return x+y; } int main() { int n=add(1, 2); return n; }" "3"
assert "int add(int x, int y) { return x+y; } int main() { return add(1, 2); }" "3"
assert "int main() { if (1) return 12; return 23; }" "12"
assert "int main() { if (2) return 12; return 23; }" "12"
assert "int main() { if (0) return 12; return 23; }" "23"
assert "int main() { if (1) return 12; else return 23; return 34; }" "12"
assert "int main() { if (2) return 12; else return 23; return 34; }" "12"
assert "int main() { if (0) return 12; else return 23; return 34; }" "23"
assert "int main() { int cond=42; if (cond) return 12; else return 23; return 34; }" "12"
assert "int main() { int cond=0; if (cond) return 12; else return 23; return 34; }" "23"
assert "int main() { int n=42; if (n==42) return 12; else return 23; return 34; }" "12"
assert "int main() { int n=42; if (n==41) return 12; else return 23; return 34; }" "23"
assert "int main() { int n=42; if (n==39+3) return 12; else return 23; return 34; }" "12"
assert "int main() { int n=42; if (n!=42) return 12; else return 23; return 34; }" "23"
assert "int main() { int n=42; if (n!=41) return 12; else return 23; return 34; }" "12"
assert "int fib(int n) { if (n==0) return n; if (n==1) return n; return fib(n-2) + fib(n-1); } int main() { return fib(10); }" "55"
assert "int main() { { int n = 2+3; return n; } return 3; }" "5"
assert "int main() { int a=12; if (1) { int n=a+23; return n; } else { return 98; } return 87; }" "35"
assert "int main() { int a=12; if (0) { int n=a+23; return n; } else { return 98; } return 87; }" "98"
assert "int main() { int a=12; if (a<12) return 12; else return 23; }" "23"
assert "int main() { int a=12; if (a<13) return 12; else return 23; }" "12"
assert "int main() { int a=12; if (a>12) return 12; else return 23; }" "23"
assert "int main() { int a=12; if (a>11) return 12; else return 23; }" "12"
assert "int main() { int a=12; if (a<=12) return 12; else return 23; }" "12"
assert "int main() { int a=12; if (a<=11) return 12; else return 23; }" "23"
assert "int main() { int a=12; if (a>=12) return 12; else return 23; }" "12"
assert "int main() { int a=12; if (a>=13) return 12; else return 23; }" "23"
assert "int main() { int i=3; for (int j=0; j<3; j++) i=i*3; return i; }" "81"
assert "int main() { int i=0; for (; i<10; i++); return i; }" "10"
assert "int main() { int i=0; for (; i<10;) { i++; } return i; }" "10"
assert "int main() { int i=1; for (i=2; i<10;) i=i*3; return i; }" "18"
assert "int main() { int i=1; for (i=3; i<10;) i=i*3; return i; }" "27"
assert "int main() { int i=1; int j=3; for (i=2; i<10; i=i*3) j=j*3; return j; }" "27"
assert "int main() { int i=0; for (; i<10; i++) { if (i==5) return i; } return 42; }" "5"
assert "int main() { if (1 && 1) return 12; else return 23; }" "12"
assert "int main() { if (1 && 0) return 12; else return 23; }" "23"
assert "int main() { if (0 && 1) return 12; else return 23; }" "23"
assert "int main() { if (0 && 0) return 12; else return 23; }" "23"
assert "int main() { if (1 || 1) return 12; else return 23; }" "12"
assert "int main() { if (1 || 0) return 12; else return 23; }" "12"
assert "int main() { if (0 || 1) return 12; else return 23; }" "12"
assert "int main() { if (0 || 0) return 12; else return 23; }" "23"
assert "int main() { int a=42; if (a<40 && a==42) return 12; else return 23; }" "23"
assert "int main() { int a=42; if (a<40 || a==42) return 12; else return 23; }" "12"
assert "int main() { if (0 || 0 || 0 || 0 || 1) return 12; else return 23; }" "12"
assert "int main() { if (0 || 0 || 0 || 0 || 0) return 12; else return 23; }" "23"
assert "int main() { if (1 && 1 && 1) return 12; else return 23; }" "12"
assert "int main() { if (1 && 1 || 0) return 12; else return 23; }" "12"
assert "int main() { if (0 || 0 && 1) return 12; else return 23; }" "23"
assert "int main() { if (0 || 1 && 1) return 12; else return 23; }" "12"
assert "int main() { char c='a'; return c; }" "97"
assert "int main() { char c='b'; return c; }" "98"
assert "int main() { char c='z'; return c; }" "122"
assert "int main() { char c='A'; return c; }" "65"
assert "int main() { char c='B'; return c; }" "66"
assert "int main() { char c='Z'; return c; }" "90"
assert "int main() { char c='a'; return sizeof(c); }" "1"
assert "int main() { char c='a'; return sizeof(char); }" "1"
assert "int main() { char c='a'; return sizeof(char*); }" "8"
assert "int main() { int a; a=42; return a; }" "42"
assert "int main() { int a; int b; a=42; return a; }" "42"
assert "int g; int main() { g=42; return g; }" "42"
assert "int ga; int gb; int main() { ga=42; gb=3; return ga; }" "42"
assert "int ga; int gb; int main() { ga=42; gb=3; return gb; }" "3"
assert "int g; int main() { return sizeof(g); }" "4"
assert "char g; int main() { return sizeof(g); }" "1"
assert "int *g; int main() { return sizeof(g); }" "8"
assert "int main() { int arr[3]; return sizeof(arr); }" "12"
assert "int main() { char arr[3]; return sizeof(arr); }" "3"
assert "int main() { return sizeof(int[3]); }" "12"
assert "int main() { int arr[3]; *arr=42; return *arr; }" "42"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return *arr; }" "3"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return *(arr+1); }" "4"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return *(arr+2); }" "5"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[0]; }" "3"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[1]; }" "4"
assert "int main() { int arr[3]; int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[2]; }" "5"
assert "int main() { int arr[3]; arr[0]=3; arr[1]=4; arr[2]=5; return arr[0]; }" "3"
assert "int main() { int arr[3]; arr[0]=3; arr[1]=4; arr[2]=5; return arr[1]; }" "4"
assert "int main() { int arr[3]; arr[0]=3; arr[1]=4; arr[2]=5; return arr[2]; }" "5"
assert "int arr[3]; int main() { int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[0]; }" "3"
assert "int arr[3]; int main() { int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[1]; }" "4"
assert "int arr[3]; int main() { int *p=arr; *p=3; p++; *p=4; p++; *p=5; return arr[2]; }" "5"
assert "int main() { char arr[3]; char *p=arr; *p='a'; p++; *p='b'; p++; *p='c'; return arr[0]; }" "97"
assert "int main() { char arr[3]; char *p=arr; *p='a'; p++; *p='b'; p++; *p='c'; return arr[1]; }" "98"
assert "int main() { char arr[3]; char *p=arr; *p='a'; p++; *p='b'; p++; *p='c'; return arr[2]; }" "99"
assert "int main() { char arr[3]; arr[0]='a'; arr[1]='b'; arr[2]='c'; return arr[0]; }" "97"
assert "int main() { char arr[3]; arr[0]='a'; arr[1]='b'; arr[2]='c'; return arr[1]; }" "98"
assert "int main() { char arr[3]; arr[0]='a'; arr[1]='b'; arr[2]='c'; return arr[2]; }" "99"
assert 'int main() { char *str = "abc"; return str[0]; }' "97"
assert 'int main() { char *str = "abc"; return str[1]; }' "98"
assert 'int main() { char *str = "abc"; return str[2]; }' "99"
assert 'int main() { char *str = "abc"; return str[3]; }' "0"
assert 'int main() { char *str = "abc"; return sizeof(str); }' "8"
assert 'int main() { char *str = "abc"; char *ss = "hello"; return str[0]; }' "97"
assert 'int main() { char *str = "abc"; char *ss = "Hello"; return ss[0]; }' "72"

# TODO:
#   Initializing an array of characters is a little bit different from that of a pointer of characters,
#   because it is necessary to assign every character to an element of an array.
# assert 'int main() { char str[4]="abc"; return str[0]; }' "97"
# assert 'int main() { char str[4]="abc"; return str[1]; }' "98"
# assert 'int main() { char str[4]="abc"; return str[2]; }' "99"
# assert 'int main() { char str[4]="abc"; return str[3]; }' "0"
# assert 'int main() { char str[4]="abc"; return *str; }' "97"
# assert 'int main() { char str[4]="abc"; char *p = str; return *p; }' "97"
# assert 'int main() { char str[4]="abc"; char *p = str; p++; return *p; }' "98"

echo OK
exit 0
