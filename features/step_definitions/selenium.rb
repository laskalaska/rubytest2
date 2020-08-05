require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://drive.google.com/drive/folders/17rV79T9fA8QLIWeNEhbvqwzoOiLdDVtA?usp=sharing"
if driver.page_source().include? 'Untitled'
  puts "File detected"
  elsif puts "Not found"
end
