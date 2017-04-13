class ApplicationForm
  include Virtus.model
  include ActiveModel::Model

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end
end