/*
Copyright SecureKey Technologies Inc. All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/

// Package api defines wallet-sdk APIs.
package api

import (
	"github.com/hyperledger/aries-framework-go/pkg/doc/did"
	"github.com/hyperledger/aries-framework-go/pkg/doc/verifiable"
	"github.com/hyperledger/aries-framework-go/pkg/kms"
)

// KeyWriter represents a type that is capable of performing operations related to key creation and storage within
// an underlying KMS.
type KeyWriter interface {
	// Create creates a keyset of the given keyType and then writes it to storage.
	// The keyID and raw public key bytes of the newly generated keyset are returned.
	Create(keyType kms.KeyType) (string, []byte, error)
}

// KeyReader represents a type that is capable of performing operations related to reading keys from an underlying KMS.
type KeyReader interface {
	// GetKey returns the public key associated with the given keyID as raw bytes.
	GetKey(keyID string) ([]byte, error)
}

// CreateDIDOpts represents the various options for the DIDCreator.Create method.
type CreateDIDOpts struct {
	KeyID            string
	VerificationType string
}

// DIDCreator defines the method required for a type to create DID documents.
type DIDCreator interface {
	// Create creates a new DID Document using the given method.
	Create(method string, createDIDOpts *CreateDIDOpts) (*did.DocResolution, error)
}

// DIDResolver defines DID resolution APIs.
type DIDResolver interface {
	// Resolve resolves a DID.
	Resolve(did string) (*did.DocResolution, error)
}

// CredentialReader defines credential reader APIs.
type CredentialReader interface {
	// Get retrieves a VC.
	Get(id string) (*verifiable.Credential, error)
	// GetAll retrieves all VCs.
	GetAll() ([]*verifiable.Credential, error)
}

// CredentialWriter defines credential write APIs.
type CredentialWriter interface {
	// Remove removes a VC.
	Remove(id string) error
	// Add adds a VC.
	Add(vc *verifiable.Credential) error
}

// Crypto defines various crypto operations that may be used with wallet-sdk APIs.
type Crypto interface {
	// Sign is not yet defined.
	Sign(msg []byte, kh interface{}) ([]byte, error)
	// Verify is not yet defined.
	Verify(signature, msg []byte, kh interface{}) error
}

// ActivityLog defines activity log related APIs.
type ActivityLog interface {
	// Log logs an activity.
	Log(message string)
}