require 'json'

File.open('results.json', 'r') do |file|
  file.readlines.each do |line|
    data = JSON.parse(line)
    digest = data["md5_digest"]
    likelihood_of_running_out_of_money = data["likelihood_of_running_out_of_money"]
    ending_portfolio_values_mean = data["ending_portfolio_values_mean"]
    puts "#{digest}\t#{likelihood_of_running_out_of_money}\t#{ending_portfolio_values_mean}"
    puts JSON.pretty_generate(data) if likelihood_of_running_out_of_money < 0.015
  end
end
