class Version
  MAYOR = 4
  MINOR = 4
  PATCH = 1

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
