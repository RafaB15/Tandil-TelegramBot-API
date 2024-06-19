class Version
  MAYOR = 4
  MINOR = 3
  PATCH = 4

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
