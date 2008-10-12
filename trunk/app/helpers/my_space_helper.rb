module MySpaceHelper
  def timelong(time)
    time ? time.strftime('%m/%d/%y %H:%M:%S') : "No Time"
  end   
end
