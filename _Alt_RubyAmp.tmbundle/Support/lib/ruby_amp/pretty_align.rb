module RubyAMP::PrettyAlign
  def pretty_align(input, separator_str=nil)
    input ||= ""
    
    if separator_str
      separator_obj = case
        when separator_str.is_a?(Regexp)
          instance_eval(separator_str.inspect)
        when separator_str.strip =~ /^\/(.+?)\/\w*$/
          instance_eval(separator_str)
        else
          separator_str
        end
      
      lines = []
      
      input.split(/\n/, -1).each do |line|
        if separator_obj.is_a?(Regexp) ? line =~ separator_obj : line[separator_obj]
          separator = ($& || separator_obj).strip
          left, right = line.split(separator_obj, 2)
          lines << [left.to_s.rstrip, separator, right.to_s.strip]
        else
          lines << [line]
        end
      end
      
      max_left      = lines.max {|a,b| !a[2] ? -1 : a[0].to_s.length <=> b[0].to_s.length }
      max_left      = max_left[0] if max_left
      max_separator = lines.max {|a,b| !a[1] ? -1 : a[1].to_s.length <=> b[1].to_s.length }
      max_separator = max_separator[1] if max_separator
      max_left      = max_left.length      if max_left
      max_separator = max_separator.length if max_separator
      
      output = []
      lines.each do |left, separator, right|
        if right
          output << format("%-#{max_left}s %-#{max_separator}s %s", left, separator, right)
        else
          output << left
        end
      end
      
      output.join("\n")
    else
      input
    end
  end
end