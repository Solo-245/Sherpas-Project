import { useReadContract } from 'wagmi'
import supplyabi from '../abis/supply.json';

export default function SupplyChainDetails() {
    const result = useReadContract({
        abi: supplyabi,
        address: '0x8e745b4Ce4d564824b486d14b2E3e240f5B148A9',
        functionName: 'SupplyChain',
      });
    return
        <section>
            <h1>SupplyDetails</h1>
            <div>Goods Supply: {result.data?.toString()} </div>
        </section>