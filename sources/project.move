module MyModule::PatientManagement {

    use aptos_framework::signer;
    use std::vector;

    /// Struct to hold patient data and consent info
    struct Patient has key, store {
        data: vector<u8>,                 // Encrypted / encoded health data
        consent_list: vector<address>,    // Addresses allowed to access data
    }

    /// Register a new patient with health data
    /// Only called once by the patient (account owner).
    public fun register_patient(account: &signer, health_data: vector<u8>) {
        let patient = Patient {
            data: health_data,
            consent_list: vector::empty<address>(),
        };
        move_to(account, patient);
    }

    /// Grant consent to another user (doctor, hospital, etc.)
    /// Adds their address to the consent list
    public fun grant_consent(account: &signer, grantee: address) acquires Patient {
        let patient = borrow_global_mut<Patient>(signer::address_of(account));
        vector::push_back(&mut patient.consent_list, grantee);
    }
}

