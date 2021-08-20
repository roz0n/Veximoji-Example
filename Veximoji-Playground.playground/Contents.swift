import UIKit
import Veximoji

var countryFlag = "DO".getCountryFlag()
var intFlag = "UN".getInternationalFlag()
var subDivFlag = "GB-WLS".getSubdivisonFlag()

var countryFlagStr = Veximoji.country(code: "DO")
var intFlagStr = Veximoji.international(code: "UN")
var subDivFlagStr = Veximoji.subdivision(code: "GB-WLS")
var culturalFlagStr = Veximoji.cultural(term: .pride)
