Given(/^user create file with ruby version$/) do
  %x`ruby -v > version`
end

When(/^user send file to google storage$/) do
  OOB_URI          = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'vanya1'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE      = Google::Apis::DriveV3::AUTH_DRIVE

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or initiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    client_id   = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer  = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id     = 'default'
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  # Initialize the API
  drive_service                                 = Google::Apis::DriveV3::DriveService.new
  drive_service.client_options.application_name = APPLICATION_NAME
  drive_service.authorization                   = authorize

  # Upload the file to Google Drive
  drive = Google::Apis::DriveV3::File.new(title: 'TestFile')
  drive = drive_service.create_file(drive, upload_source: 'version', content_type: 'text/plain')
end

Then(/^check file with selenium$/) do
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to "https://drive.google.com/drive/folders/17rV79T9fA8QLIWeNEhbvqwzoOiLdDVtA?usp=sharing"
  if driver.page_source().include? 'Untitled'
    puts "File detected"
  elsif puts "Not found"
  end
end