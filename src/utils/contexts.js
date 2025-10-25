import { createContext, useContext, useEffect, useState } from "react";
import inputTypes from "../constants/inputType";
import { getValue } from "./storage";

const TransactionContext = createContext();

export function TransactionProvider({ children }) {
  const [inputAmount, setInputAmount] = useState("");
  const [totalAmount, setTotalAmount] = useState();
  const [inputType, setInputType] = useState(inputTypes[1]);
  const [transactionTags, setTransactionTags] = useState([]);
  const [transactionDateTime, setTransactionDateTime] = useState(null);

  useEffect(() => {
    async function fetchTotal() {
      const total = await getValue("total");
      setTotalAmount(total || "0");
    }
    fetchTotal();
  }, []);

  const value = {
    inputAmount,
    setInputAmount,
    totalAmount,
    setTotalAmount,
    inputType,
    setInputType,
    transactionTags,
    setTransactionTags,
    transactionDateTime,
    setTransactionDateTime,
  };

  return (
    <TransactionContext.Provider value={value}>
      {children}
    </TransactionContext.Provider>
  );
}

// Custom hook to use the transaction context
export function useTransaction() {
  const context = useContext(TransactionContext);
  if (!context) {
    throw new Error("useTransaction must be used within a TransactionProvider");
  }
  return context;
}

// Optional: Individual hooks for cleaner access
export function useInput() {
  const { inputAmount, setInputAmount } = useTransaction();
  return { inputAmount, setInputAmount };
}

export function useTotal() {
  const { totalAmount, setTotalAmount } = useTransaction();
  return { totalAmount, setTotalAmount };
}

export function useInputType() {
  const { inputType, setInputType } = useTransaction();
  return { inputType, setInputType };
}

export function useTransactionTags() {
  const { transactionTags, setTransactionTags } = useTransaction();
  return { transactionTags, setTransactionTags };
}

export function useTransactionDateTime() {
  const { transactionDateTime, setTransactionDateTime } = useTransaction();
  return { transactionDateTime, setTransactionDateTime };
}
