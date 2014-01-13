class String
  def friendlyerize
    gsub("\'", "").parameterize
  end
end