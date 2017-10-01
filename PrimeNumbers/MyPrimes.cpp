#include <iostream>
#include <vector>
#include "PrimeNumbers.h"
#include <fstream>
#include <sstream>
#include <chrono>

int main(int argc, char **argv)
{
    
    // Prepare time measurement for program execution
    std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
    start = std::chrono::high_resolution_clock::now();
    
    // user input do define array size
    unsigned N;
    std::istringstream ss(argv[1]);
    if(!(ss >> N))
        std::cerr << "Enter an integer value greater than 2" << std::endl;
    
    PrimeNumbers prime_array(N);
    prime_array.get_primes();
    prime_array.get_twins();
    prime_array.save();
    //prime_array.display();

    end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_seconds = end - start;
    std::cout << " Time elapsed: " << elapsed_seconds.count() << " s" << std::endl;

    return 0;
}
