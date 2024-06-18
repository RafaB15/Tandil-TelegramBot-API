class Version
  MAYOR = 3
  MINOR = 1
  PATCH = 3

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
