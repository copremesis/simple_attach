class UploadController < ApplicationController
  def index
    #forward to view for now
    #build list of attachments
    @files = `ls #{Rails.root.join('public','uploads')}`.split(/\n/) 
  end

  #POST to this action will get the file
  #code here shall go into a sub folder class known as 
  
  def attach
    #simplest form of attachment
    uploaded_io = params[:upload][:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    #something happens here like book keeping or conversion etc
    redirect_to :root
  end
end
