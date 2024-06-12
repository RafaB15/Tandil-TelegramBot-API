class Version
  MAYOR = 0
  MINOR = 13
  PATCH = 8

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
