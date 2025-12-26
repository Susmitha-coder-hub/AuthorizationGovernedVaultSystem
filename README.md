Your README content is correct in **idea**, but the **formatting is broken** (mixed code blocks, headings, and text).
Below is a **clean, correct, copy-paste–ready README.md** with **clear execution steps**.

---

# ✅ **Corrected `README.md` (FINAL)**

````md
# Secure Vault System

## Overview
This project demonstrates a secure two-contract architecture:

- **SecureVault** — holds ETH and executes withdrawals  
- **AuthorizationManager** — validates and consumes withdrawal permissions  

The vault never verifies signatures directly and relies entirely on the authorization manager.

---

## Requirements

Make sure you have installed:

- Docker
- Docker Compose
- Node.js (v18+ recommended)

Verify:
```bash
docker --version
docker-compose --version
node -v
````

---

## How Authorization Works

1. An off-chain signer creates a hash containing:

   * Vault contract address
   * Chain ID
   * Recipient address
   * Withdrawal amount
   * Unique nonce

2. The signer signs this hash off-chain.

3. The signed authorization is submitted to the vault.

4. The vault forwards the data to `AuthorizationManager`.

5. The authorization manager:

   * Verifies the signature
   * Ensures it has not been used before
   * Marks it as consumed
   * Returns approval

6. The vault transfers ETH exactly once.

---

## Run Locally (Docker)

### Step 1: Install dependencies

```bash
npm install
```

---

### Step 2: Start the system

```bash
docker-compose up --build
```

This will:

* Start a local blockchain (Ganache)
* Compile smart contracts
* Deploy `AuthorizationManager`
* Deploy `SecureVault`
* Print deployed contract addresses to logs

---

### Step 3: Observe deployment logs

You should see output similar to:

```
Deployer: 0x...
Chain ID: 31337
AuthorizationManager: 0x...
SecureVault: 0x...
```

---

### Step 4: RPC Endpoint

The local blockchain RPC is available at:

```
http://localhost:8545
```

You can connect using:

* MetaMask
* Remix
* Hardhat console

---

## Run Tests (Optional)

In a new terminal:

```bash
npx hardhat test
```

Expected result:

```
✔ Allows withdrawal only once per authorization
```

---

## Security Guarantees

* One-time authorization usage
* Replay protection via nonce + chainId
* Effects-before-interactions pattern
* Vault never performs signature verification
* Authorization tightly bound to vault, chain, recipient, and amount

---

## Project Structure

```
/
├─ contracts/
│  ├─ SecureVault.sol
│  └─ AuthorizationManager.sol
├─ scripts/
│  └─ deploy.js
├─ tests/
│  └─ system.spec.js
├─ docker/
│  ├─ Dockerfile
│  └─ entrypoint.sh
├─ docker-compose.yml
└─ README.md
```

---

## Notes

* Authorizations cannot be reused
* Withdrawals revert deterministically on failure
* System is safe under repeated or unexpected calls

```

---

# 🎯 What You Can Say in an Interview

> “I built a two-contract vault system where custody and authorization are separated. Withdrawals require off-chain signed permissions that are verified and consumed exactly once on-chain, preventing replay attacks and double-spends. The system is dockerized and fully reproducible locally.”

---

If you want next, I can:
- Show **exact off-chain JS code to generate signatures**
- Add **EIP-712 typed data**
- Convert this to **Foundry**
- Add **reentrancy protection discussion**

Just tell me 👍
```
