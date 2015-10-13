#Simple Attach

###Chapter 1.
start new rails instance
```bash
rails new simple_attach
```
* create controller
```bash
rails g upload
```

* create simple form  __root/app/views/upload/index.html.erb__
```html
<form method=POST action= '/upload' enctype="multipart/form-data">
  <input name="upload[file]" type=file /> <br>
  <input type=submit value=upload>
</form>
```
* create routes __root/config/routes.rb__
```ruby
SimpleAttach::Application.routes.draw do
  root 'upload#index'
  post '/upload' => 'upload#attach'
end
```
* process file  __root/app/controllers/index.rb__
```ruby
  def attach
    #simplest form of attachment
    uploaded_io = params[:upload][:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    #something happens here like book keeping or conversion etc
    redirect_to :root
  end
```

* modify upload page to list files

inside _upload#index_ controller:
```ruby
  @files = `ls #{Rails.root.join('public','uploads')}`.split(/\n/) 
```

inside view:
```erb
<% @files.each do |file| %>
<%= file %> <br>
<% end %>
```

###Chapter 2.

lets get ajaxy and do some HTML5 or something cool like drag and drop 
so we can add slew of files all at once ... 
we're a car dealer
      a web designer
      real estate ajent
      golf coach
      music major

we don't want to drag or type out 100's of names to images ... when we can select them all using the file explorer
then upload them in one swoop with a progress bar status I think that is good for today's standards


###Chapter 3. 
DB sync and how to migrate uploads as 
  repo
  automous DB
  etc ..



