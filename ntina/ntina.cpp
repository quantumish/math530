#include <Eigen/Dense>
#include <iostream>


bool ensure_valid(Eigen::MatrixXf ntina) {
    int n = ntina.rows();
    for (int i = 0; i < n; i++) {
	if (ntina(i,i) == 1) return false;
    }

    for (int i = 0; i < n-1; i++) {
	for (int j = 0; j < n-1-i; j++) {	    
	    if (ntina(i, j+i+1) == 1 && ntina(j+i+1, i) == 1) return false;
	}
    }
    
    return true;
}

int main() {
    for (int n = 1; n < 100; n++) {
	Eigen::MatrixXf ntina(n,n);
	for (int i = 1; i <= ntina.rows(); i++) {
	    for (int j = 1; j <= ntina.cols(); j++) {
		(i==2*j || i==2*(n-j)+1) ? ntina(i-1,j-1) = 1 : ntina(i-1,j-1) = 0;
	    }
	}
	if (ensure_valid(ntina)) {
	    std::cout << n << ",";
	} 
    }
    std::cout << "\n";
}
