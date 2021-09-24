#include <Eigen/Dense>
#include <random>
#include <iostream>
#include <cmath>
#include <complex>
using namespace std::literals;

#ifdef PYTHON
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/eigen.h>
namespace py = pybind11;
#endif

Eigen::MatrixXcf generate_matrix(unsigned int n) {
    std::random_device dev;
    std::mt19937 rng(dev());
    std::uniform_real_distribution<double> dist(0, 1);
    std::vector<double> a;
    Eigen::MatrixXcf M(n, n);
    // initialize random variables
    for (int i = 0; i < pow(n, 2); i++) {
	a.push_back(dist(rng));
	// std::cout << a[i] << "\n";
    }
    // construct matrix
    for (int i = 0; i < n; i++) {
	M(i, i) = a[i];
    }
    int a_index = 0;
    for (int i = 0; i < n-1; i++) {
	for (int j = 0; j < n-1-i; j++) {
	    std::complex<double> pair = (a[a_index]+(a[a_index+1]*1i))/sqrt(2);
	    std::complex<double> inv_pair = (a[a_index]-(a[a_index+1]*1i))/sqrt(2);
	    M(i, j+i+1) = pair;
	    M(j+i+1, i) = inv_pair;
	    a_index++;
	}
    }
    return M;
}

std::vector<double> generate_gue_dets(unsigned int n, unsigned int iters) {    
    std::vector<double> dets;
    for (int i = 0; i < iters; i++) {
	Eigen::MatrixXcf M = generate_matrix(n);
	dets.push_back(M.determinant().real());
    }
    return dets;
}

int main()
{
    generate_gue_dets(2, 10);
    return 0;
}

#ifdef PYTHON
PYBIND11_MODULE(gue, m) {
    m.doc() = "Generates GUEs.";	
    m.def("generate_gue_dets", &generate_gue_dets, py::arg("n"), py::arg("iters"));
}
#endif
