import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>Chart Data</title>
        <meta name="description" content="Chart Data" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Chart Data
        </h1>

        <p className={styles.description}>
          Get started clicking any link below
        </p>

        <div className={styles.grid}>
          <a href="/basefeeChart"
            className={styles.card}
          >
            <h2>Basefee data &rarr;</h2>
            <p>
              View data related to Ethereum block basefee.
            </p>
          </a>
          <a href="/gasRatioChart"
            className={styles.card}
          >
            <h2> Gas Ratio data &rarr;</h2>
            <p>
              View data related to Ethereum block gas use.
            </p>
          </a>
          <a href="/tetherTxChart"
            className={styles.card}
          >
            <h2> Transfers on tether &rarr;</h2>
            <p>
              View data related to transfers of the ERC20 token, Tether.
            </p>
          </a>
        </div>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{' '}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  )
}
