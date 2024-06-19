class Version
  MAYOR = 4
  MINOR = 6
  PATCH = 0

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
