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

* create simple form  _root/app/views/upload/index.html.erb_
```html
<form method=POST action= '/upload' enctype="multipart/form-data">
  <input name="upload[file]" type=file /> <br>
  <input type=submit value=upload>
</form>
```
* create routes _root/config/routes.rb_
```ruby
SimpleAttach::Application.routes.draw do
  root 'upload#index'
  post '/upload' => 'upload#attach'
end
```
* process file  _root/app/controllers/index.rb_
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
example use:<br>

![Imgur](http://i.imgur.com/uyRL8HT.png)

###Chapter 2.

Adding bootstrap to the project.

I made a copy of the application layout file and named it _bootstrap.rb_

```erb
<!DOCTYPE html>
<html>
<head>
  <title>SimpleAttach</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>


  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

</head>
<body>

<%= yield %>

</body>
</html>
```

The markup for the upload view now becomes:

```html
<form method=POST action= '/upload' enctype="multipart/form-data">
    <div class='container'>
      <div class="row">
        <div class="col-md-6">
          <input name="authenticity_token" value="<%= form_authenticity_token %>" type="hidden">
          <input name="files[]" type=file multiple/> 
        </div>
        <div class="col-md-6">
          <input type=submit value=upload>
        </div>
      </div>
    </div>
</form>

```

When setting this up I skipped over the authenticity_token
to get a working application ... here's the line i commented before inside the application controller.

```ruby
  protect_from_forgery with: :exception
```

Also the to handle multiple files renamed the field name for files as such:

```
  <input name="files[]" type=file multiple/> 
```

The controller that handles this has now become:

Inside the index controller I add this to use the bootstrap layout.

```
    render :layout => 'bootstrap'
```
and to handle multiple files we now have:

```ruby
  def attach
    #simplest form of attachment
    (params[:files] || []).each {|uploaded_io|
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    }
    #something happens here like book keeping or conversion etc
    redirect_to :root
  end
```

New look and tests performed
![bootstrap added](http://i.imgur.com/08bLoEi.png)

###Chapter 3. 
Do we need a database to attach files? This was the primary reason for my need to abandon applications
that center around a database -- hence the use of backticks vs sql queries 

```ruby
    @files = `ls #{Rails.root.join('public','uploads')}`.split(/\n/) 
```

Which keeps this light and thin 
Also if I need to migrate this from one system dev->stage->production to another there's no 
database to align with a file system. The file system is the __database__.


If anything we now are at a place where we should write tests and refactor as the code is becoming complex.

###Chapter 4. 

Lets get ajaxy and do some HTML5 or something cool like drag and drop 

so we can add slew of files all at once ... 
possbile use cases:

* a car dealer
* a web designer
* real estate agent
* golf coach
* music major

we don't want to drag or type out 100's of files when we can select them all using the file explorer
then upload them in one swoop with a progress bar status I think that is good for today's standards


###Chapter 6.

Blocking I/O will kill mobile. We must have an invisible _fast_ backend system to maximize the power of our handheld device.

optimize 
  * backgroundjob
  * redis/resque

###Chapter 7. 
  mime types 

  Now that we've transfered 1's & 0's from somwhere to our mother ship server lets now do something with these files:

  render drawings ... build a montage ... 
  create an animation etc ... 



