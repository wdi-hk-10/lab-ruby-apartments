$roster = ['Judah Frankel', 'Daryl Chu', 'Sean Ng', 'Carmen Taubman', 'Jinny Lee', 'Shawn Alwani', 'Jon Young', 'Sean Ng', 'Jules Waite', 'Robert Fong']

puts $roster.inspect



def student_total
  puts 'There are ' + $roster.length.to_s + ' students in the class.'
end

student_total

def add_student new_student
  h = {}
  h[:name] = new_student
  $roster << h
end

add_student('Willie Tong')

puts $roster.inspect

student_total