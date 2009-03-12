# To change this template, choose Tools | Templates
# and open the template in the editor.

module StringUtil
  class << self
    def truncate_u(text, length = 30, truncate_string = "...")
      l=0
      char_array=text.unpack("U*")
      char_array.each_with_index do |c,i|
        l = l+ (c<127 ? 0.5 : 1)
        if l>=length
          return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
        end
      end
      return text
    end
  end
end
