class Version
  MAYOR = 1
  MINOR = 1
  PATCH = 5

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
