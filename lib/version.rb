class Version
  MAYOR = 0
  MINOR = 3
  PATCH = 5

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
