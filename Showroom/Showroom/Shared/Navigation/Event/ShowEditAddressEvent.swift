import Foundation

struct ShowEditAddressEvent: NavigationEvent {
    let formFields: [AddressFormField]
    let editingState: CheckoutDeliveryEditingState
}