#include "PrimeNumbers.h"
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>

// Definition of constructors
PrimeNumbers::PrimeNumbers(unsigned N)
    : m_boolVector(N, true)
{
}
// Definition of destructors
PrimeNumbers::~PrimeNumbers()
{
}

// Definition of functions

void PrimeNumbers::get_primes()
{
    // Sort out all even numbers and one
    m_boolVector[0] = false;
    for (auto i = 3; i < (m_boolVector.size()); i += 2) {
        m_boolVector[i] = false;
    }

    // Main loop for finding primes
    for (auto i = 3; i * i < m_boolVector.size(); i += 2) {
        if (m_boolVector[i-1]) {
            for (auto j = i * i; j <= m_boolVector.size(); j += i)
                m_boolVector[j-1] = false;
        }
    }

    // Write primes in m_primeVector
    unsigned nCounter = 0;
    for (auto i = m_boolVector.begin(); i != m_boolVector.end(); ++i) {
        ++nCounter;
        if (*i)
            m_primeVector.push_back(nCounter);
    } 
}

void PrimeNumbers::save()
{
    // Save prime numbers to text file
    std::ofstream prime_file;
    const std::string dir_primes = "prime_numbers.txt";
    prime_file.open(dir_primes);
    unsigned prime_count = 0;
    for (auto i = 0; i != m_primeVector.size(); ++i) {
        prime_file << m_primeVector[i] << "\n";
        ++prime_count;
    }
    prime_file.flush();
    prime_file.close();
    std::cout << prime_count << " prime numbers were saved to " << dir_primes << " !" << std::endl;

    // Save prime twins to text file
    std::ofstream twin_file;
    const std::string dir_twins = "twin_primes.txt";
    twin_file.open(dir_twins);
    unsigned twin_count = 0;
    for (auto &pair : m_twinVector) {
        for (auto prime : pair)
            twin_file << prime << " ";
        twin_file << "\n";
        ++twin_count;
    }
    twin_file.flush();
    twin_file.close();
    std::cout << twin_count << " prime twins were saved to " << dir_twins << " !" << std::endl;


}

void PrimeNumbers::display()
{
    /*
    for (auto it = m_primeVector.begin(); it != m_primeVector.end(); ++it)
        std::cout << *it << std::endl; 
        */
    for (auto &pair : m_twinVector) {
        for (auto twin : pair)
            std::cout << twin << " " ;
        std::cout << std::endl;
    }
}

void PrimeNumbers::get_twins()
{
    unsigned last_prime(1);
    unsigned twin_count(0);

    for (auto it : m_primeVector) {
        if (it == last_prime + 2) {
            std::vector<unsigned> twin_pair{last_prime, it};
            m_twinVector.push_back(twin_pair);
            ++twin_count;
        }
        last_prime = it;
    }
}
