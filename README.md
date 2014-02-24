Burn Plan (Financial Simulator)
=========
Simulates your personal financial portfolio
---------
1. Set your inflation mean and stddev
2. Define your various asset classes and their means and stddevs
3. Create your portfolio of assets
4. Enter your tax rates
5. Decide how much you need to distribute each year to live on
6. Decide if you will rebalance each year
7. Enter how long you expect to live
8. Enter the number of simulations you want to run
9. View your results

Results tell you
---------
1. Your average ending portfolio value when you died
2. The number of simulations where you ran out of money before you died
3. The percentage likelihood that you will run out of money before you die
4. The average distribution you took out your portfolio each year

Usage
---------
    cd burn_plan
    bundle
    ruby -Ilib bin/burnit.rb
