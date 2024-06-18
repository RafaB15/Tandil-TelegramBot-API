class Version
  MAYOR = 2
  MINOR = 0
  PATCH = 3

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
