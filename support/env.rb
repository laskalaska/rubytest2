require 'capybara'
require 'selenium-webdriver'
require "google/apis/drive_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

Capybara.register_driver :driver do |app|
  case ENV['DRIVER']
  when 'chrome'
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  when 'without_browser'
    Capybara.default_driver = :mechanize
  else
    client  = Selenium::WebDriver::Remote::Http::Default.new
    Capybara::Selenium::Driver.new(app, :browser => :firefox, port: 10000 + Random.rand(1000), http_client: client)
  end
end

Capybara.default_driver   = :driver
Capybara.default_selector = :xpath
