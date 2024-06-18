class Version
  MAYOR = 3
  MINOR = 0
  PATCH = 0

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
