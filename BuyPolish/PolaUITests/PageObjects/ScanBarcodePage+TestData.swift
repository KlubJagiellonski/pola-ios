import XCTest

extension ScanBarcodePage {
    func enterCodeAndWaitForResult(codeData: CodeData, file: StaticString = #file, line: UInt = #line) -> ScanBarcodeWithResultsPage {
        return tapEnterBarcodeButton()
            .inputBarcode(codeData.barcode)
            .tapOkButton()
            .waitForResultPage(expectedResult: codeData.result, file: file, line: line)
    }

    func enterCodeAndOpenResult<T: ResultPage>(codeData: CodeData, expectedResultType _: T.Type) -> T {
        return tapEnterBarcodeButton()
            .inputBarcode(codeData.barcode)
            .tapOkButton()
            .waitForResultPage(expectedResult: codeData.result)
            .tapOnNewestResultCard(expectedResultType: T.self)
    }

    func enterCodeAndOpenCompanyResult(codeData: CodeData) -> CompanyPage {
        return enterCodeAndOpenResult(codeData: codeData, expectedResultType: CompanyPage.self)
    }

    func enterCodeAndOpenISBNResult() -> ISBNPage {
        return enterCodeAndOpenResult(codeData: CodeData.ISBN, expectedResultType: ISBNPage.self)
    }
}
