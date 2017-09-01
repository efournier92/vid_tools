require 'pry'
require 'fileutils'

def valid_folder? folder_name
  if folder_name.start_with?('.')
    false
  elsif folder_name == 'EP' || folder_name == 'FULL'
    false
  else
    true
  end
end

def spread_vids
  directory = '/Volumes/M_EXTENDED/PRJTS/Opry/GD/'
  files = Dir.entries(directory)
  counter = 1
  files.each do |file|
    if valid_folder? file
      FileUtils.mv("#{directory}/#{file}", "#{directory}EP/#{'%02d' % counter}/#{file}")
      counter += 1
      counter = 1 if counter == 21
    end
  end
end

def get_dir_duration
  directory = '/Volumes/M_EXTENDED/PRJTS/Opry/FINAL'
  ep_folders = Dir.entries(directory)

  ep_folders.each do |folder|
    if valid_folder? folder
      ep_duration = 0
      ep_directory = "#{directory}/#{folder}"
      files = Dir.entries(ep_directory)

      files.each do |file|
        if file != '.' && file != '..'
          file_path = "#{directory}/#{folder}/#{file}"
          file_path = Shellwords.escape(file_path)

          file_duration = get_movie_duration(file_path)
          ep_duration = ep_duration + file_duration
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
  timestamp = /duration: ([0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{2})/i.match(ffmpeg_output)
  if timestamp && !File.directory?(video_file)
    timestamp = timestamp[1] 

    hours   = timestamp[0,2].to_i
    minutes = timestamp[3,2].to_i
    seconds = timestamp[6,2].to_i

    total_seconds = 0.00
    total_seconds = seconds + (minutes * 60) + (hours * 360)
    total_minutes = total_seconds / 60
  end
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

mode = ""
until mode == '1' || mode == '2' || mode == '3' do
  print "SELECT MODE:\n  1) Get Dir Duration\n  2) Spread Files\n  3) Write Concats\n>> "
  mode = gets.chomp
end

get_dir_duration   if mode == '1'
spread_vids        if mode == '2'
write_concat_files if mode == '3'

