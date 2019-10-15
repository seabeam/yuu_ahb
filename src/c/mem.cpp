#include <iostream>
#include <memory.h>

using namespace std;

typedef unsigned char byte_t;

class c_mem {
	private:
		byte_t*	m_mem;
		int		m_base_addr;
		int		m_depth;

	public:
		c_mem(int base_addr) { m_base_addr = base_addr; }
		~c_mem() { delete m_mem; }
		void set_depth(int size);
		void init_mem();
};

void c_mem::set_depth(int size) {
	m_depth = size;
	m_mem = new byte_t [size];
}

void c_mem::init_mem() {
	memset(m_mem, 0xf, m_depth);
}
