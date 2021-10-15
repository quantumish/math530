#include <Eigen/Dense>
#include <iostream>
#include <vector>
#include <cstdio>

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

bool ensure_really_valid(Eigen::MatrixXf ntina) {
    int n = ntina.rows();
    Eigen::MatrixXf n_p = ntina;
    std::vector<Eigen::MatrixXf> cache;
    cache.push_back(ntina);
    for (int i = 0; i < (n-1); i++) {
        Eigen::MatrixXf n_i = n_p * ntina;
        for (int j = 0; j < cache.size(); j++) {
            if (n_i == cache[j]) {
                std::cout << "N^" << j << " = " << "N^" << i << "\n";
                return false;
            }
        }
        cache.push_back(n_i);
        n_p = n_i;
    }
    return true;
}

int main() {
    for (int n = 1; n < 25; n++) {
        Eigen::MatrixXf ntina(n,n);
        for (int i = 1; i <= ntina.rows(); i++) {
            for (int j = 1; j <= ntina.cols(); j++) {
                (i==2*j || i==2*(n-j)+1) ? ntina(i-1,j-1) = 1 : ntina(i-1,j-1) = 0;
            }
        }
        if (ensure_valid(ntina)) {
            if (ensure_really_valid(ntina) == false) {
                std::cout << n << "\n==========\n";
                printf("   "); for (int i=0; i<n; ++i) printf("%3d", i+1);
                for (int i=0; i<n; ++i) {
                    printf("\n%3d", i+1); 
                    for (int j=0; j<n; ++j) 
                        printf("%3c", (ntina(i, j) == 0)? '.' : '#');
                } printf("\n");
                std::cout << "==========\n";
                // for (int i = 0; i < ntina.rows(); i++) {
                //     for (int j = 0; j < ntina.cols(); j++) {
                //         std::cout << ((ntina(i, j) == 0) ? ". " : "# ");
                //     }
                //     std::cout << "\n";
                // } 
                // std::cout << ntina << "\n";
                // std::cout << " (not rly tho)";
            }
        } 
    }
    std::cout << "\n";
    
}
