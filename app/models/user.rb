class User < ActiveRecord::Base
  has_secure_password validations: false

  VALID_NEIGHBOURHOOD_TYPES = [ "Orleans", "Innes", "Barrhaven", "Kanata North",
    "West Carleton-March", "Stittsville", "Bay", "College", "Rideau-Rockcliffe",
    "Somerset", "Kitchissippi", "River", "Capital", "Alta Vista", "Cumberland", "Osgoode",
    "Rideau-Goulbourn", "Gloucester-South Nepean", "Kanata South", "Knoxdale-Merivale",
    "Gloucester-Southgate", "Beacon Hill-Cyrville", "Rideau-Vanier"]

  VALID_ROLE_TYPES = ["Public", "City Official", "Organization", "Urban Developer"]

  before_create do |doc|
    doc.api_key = doc.generate_api_key
  end

  has_many :comments, as: :commentable

  # Rating
  ratyrate_rater

  validates               :email,
                            presence: {message: "Email is required"},
                            uniqueness: {message: "Email already in use"}
  validates               :password,
                            presence: {message: "Password is required", on: :create},
                            confirmation: {message: "Passwords do not match."},
                            length: { in: 6..20, message: "Password must be between 6 to 20 characters"}


  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end


end
