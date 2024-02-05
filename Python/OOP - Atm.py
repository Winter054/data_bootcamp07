# Create new ATM class with 5 method

class ATM:
    def __init__(self, name, bank, balance):
        self.name = name
        self.bank = bank
        self.balance = balance
    def check(self):
        print(f"Your balance: {self.balance} Baht.")

    def deposit(self, amount):
        self.balance += amount
        print(f"Your deposit amount is {amount} Baht. Your balance: {self.balance} Baht.")

    def withdraw(self, amount):
        self.balance -= amount
        print(f"Your withdraw is {amount} Baht. Your balance: {self.balance} Baht.")

    def transfer(self, bank, trf):
        self.balance -= trf
        print(f"You've chosen to transfer {trf} Baht to {bank}. Your balance: {self.balance} Baht.")

    def pay(self, shop, fee):
        self.balance -= fee
        print(f"Your payment to {shop} is total {fee} Baht, Your balance: {self.balance} Baht.")
