import Foundation
import CocoaMarkdown

final class TrendProductListModel: ProductListModel {
    
    //todo it should be created in background on rx network chain
    var description: NSAttributedString {
        return headerDescription.markdownToAttributedString()
    }
    
    override init(with apiService: ApiService) {
        super.init(with: apiService)
    }
}

//TODO:- remove when model will exist

extension TrendProductListModel {
    private var headerDescription: String {
        return "**Latem 2016** najmodniejsze kolory pochodzą ze **świata natury**. **New Neutrals** to piaskowy, ochra, kość słoniowa, khaki, orzechowy i zgniła zieleń. Naśladują barwy **suchych traw**, kolory **pustyni**, **skał**, **gliny**, a nawet **skóry**. Kolory natury **pasują każdemu** - blondynki poczują się naturalnie w odcieniach **khaki**, natomiast ciemne włosy brunetek będą świetnie kontrastować z **jasnymi beżami**. Jak nosić barwy ziemi? Zielenie nawiązują do wciąż modnego stylu **militarnego**, wyblakłe brązy wpisują się w trendy **eko**, a **beżowy total look** to nowa, zmysłowa tendencja, którą zapoczątkowała Kim Kardashian. Jesteś **uwodzicielska**, **wojownicza** czy **ekologiczna**? Latem 2016 postaw na **naturalne kolory** i znajdź wśród nich ten, który podkreśla Twoją osobowość!"
    }
}