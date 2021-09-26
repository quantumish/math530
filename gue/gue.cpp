#include <Eigen/Dense>
#include <random>
#include <iostream>
#include <cmath>
#include <complex>
#include <thread>
#include <chrono>
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
    std::normal_distribution<double> dist;
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

std::vector<double> generate_gue_traces(unsigned int n, unsigned int iters) {    
    std::vector<double> traces;
    for (int i = 0; i < iters; i++) {
	Eigen::MatrixXcf M = generate_matrix(n);
	traces.push_back((M*M).trace().real());
    }
    return traces;
}

// Not a good idea
// std::vector<double> pgenerate_gue_dets(unsigned int n, unsigned int iters) {
//     unsigned int cores = std::thread::hardware_concurrency();
//     std::vector<std::thread> threads;
//     for (int core = 0; core < cores; core++) {
// 	threads.emplace_back(generate_gue_dets, n, iters);
//     }
//     for (int i = 0; i < cores; i++) {
// 	threads[i].join();
//     }
// }

int main()
{
    pgenerate_gue_dets(5, 10);
    return 0;
}

#ifdef PYTHON
PYBIND11_MODULE(gue, m) {
    m.doc() = "Generates GUEs.";	
    m.def("generate_gue_dets", &generate_gue_dets, py::arg("n"), py::arg("iters"));
    m.def("generate_gue_traces", &generate_gue_traces, py::arg("n"), py::arg("iters"));
}
#endif


// p1: see code
// p2: higher mean, higher stddev, higher kurtosis
// p3: see code
// p4: solve analytically?
