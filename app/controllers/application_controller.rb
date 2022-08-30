class ApplicationController < ActionController::Base
  def path_to_string(path)
    unless path == "None\n"
      start = path.index("'") + 1
      final = path.index(".xlsx") + 4
      path[start..final]
    else
      "NotChosen"
    end
  end
end
