


def get_vid_duration file_path

    string = get_movie_duration(file_path)
    hours = string[0,2].to_i
    minutes = string[3,2].to_i
    seconds = string[6,2].to_i

end

