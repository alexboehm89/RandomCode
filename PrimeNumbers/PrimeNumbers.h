#include <vector>

#ifndef __PRIME_NUMBERS__
#define _PRIME_NUMBERS__


class PrimeNumbers
{
    public:
        // Constructors
        PrimeNumbers(unsigned N);
        // Destructor
        ~PrimeNumbers();
        // Functions
        void get_primes();
        void save();
        void display();
        void get_twins();


    private:
        std::vector<bool> m_boolVector;
        std::vector<unsigned> m_primeVector;
        std::vector< std::vector<unsigned> > m_twinVector;

};


#endif
