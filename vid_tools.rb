
def spread_vids
end

def get_dir_duration
  video_file_len = get_movie_duration(video_file)

  directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/EP/'
  ep_folders = Dir.entries(directory)

  ep_folders.each do |folder|
    if folder != '.' && folder != '..' 
      ep_duration = 0
      ep_directory = "#{directory}#{folder}"
      files = Dir.entries(ep_directory)

      files.each do |file|
        if file != '.' && file != '..'
          file_path = "#{directory}#{folder}/#{file}"
          file_path = Shellwords.escape(file_path)

          file_duration = get_vid_duration(file_path)
          ep_duration = ep_duration + file_duration
          # binding.pry
        end
      end
      puts "#{folder}: #{ep_duration}"
    end
  end
end

def write_concat_files video_file
  directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/EP/'
  out_directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/EP/ls'
  ep_folders = Dir.entries(directory)

  ep_folders.each do |folder|
    if folder != '.' && folder != '..' 
      out_file = File.new("#{out_directory}/#{folder}.txt", "w")
      ep_directory = "#{directory}#{folder}"
      files = Dir.entries(ep_directory)

      files.each do |file|
        if file != '.' && file != '..'
          file_path = "#{directory}#{folder}/#{file}"
          file_path = Shellwords.escape(file_path)

          out_file.puts("file #{file_path}")

          # binding.pry
        end
      end
      out_file.close
    end
  end
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

video_file = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/Anne\ Murray\ -\ You\ Needed\ Me-e6nfpxZ2Nz4.mp4'
def get_vid_duration file_path
  string = get_movie_duration(file_path)

  hours = string[0,2].to_i
  minutes = string[3,2].to_i
  seconds = string[6,2].to_i

  total_seconds = 0
  total_seconds = seconds + (minutes * 60) + (hours * 360)
  total_minutes = total_seconds / 60
end

