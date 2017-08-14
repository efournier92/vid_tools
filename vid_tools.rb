
def write_concat_files video_file
  directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/EP/'
  out_directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/EP/ls'
  ep_folders = Dir.entries(directory)

end

def get_movie_duration video_file
  # Run ffmpeg on the video, and do it silently
  ffmpeg_output = `ffmpeg -i #{video_file} 2>&1`

  # Find the duration in the output, and force a return if it's found
  duration = /duration: ([0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{2})/i.match(ffmpeg_output) { |m| return m[1] }

  binding.pry
  # If it didn't get a match, something is wrong. Log the error
  return "FFMPEG ERROR"
end

def get_vid_duration file_path
  string = get_movie_duration(file_path)

  hours = string[0,2].to_i
  minutes = string[3,2].to_i
  seconds = string[6,2].to_i

  total_seconds = 0
  total_seconds = seconds + (minutes * 60) + (hours * 360)
  total_minutes = total_seconds / 60
end

