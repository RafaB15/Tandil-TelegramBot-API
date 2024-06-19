class Version
  MAYOR = 4
<<<<<<< HEAD
  MINOR = 5
  PATCH = 1
=======
  MINOR = 6
  PATCH = 0
>>>>>>> 96f348bba976aa93e3e27873f64ed0e6ace1bdff

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
