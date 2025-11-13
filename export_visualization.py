#!/usr/bin/env python3
"""
Bank Segmentation Visualization Script

This script connects to a PostgreSQL database, executes segmentation queries,
and generates a bar chart showing the top 5 customer segments by count.

Requirements:
- psycopg2-binary
- matplotlib

Install with: pip install psycopg2-binary matplotlib

Usage:
python export_visualization.py

Ensure PostgreSQL is running and the database is set up with the schema and data.
"""

import psycopg2
import matplotlib.pyplot as plt

# Database connection parameters (update as needed)
DB_HOST = "localhost"
DB_NAME = "bank_segmentation"
DB_USER = "postgres"
DB_PASSWORD = "password"  # Change to your password
DB_PORT = 5432

def get_segment_counts():
    """
    Connect to the database and retrieve counts for various customer segments.
    """
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT
        )
        cursor = conn.cursor()

        # Query for high-value customers (top 20 by total credits)
        cursor.execute("""
            SELECT COUNT(DISTINCT c.customer_id) AS count
            FROM customers c
            JOIN accounts a ON c.customer_id = a.customer_id
            JOIN transactions t ON a.account_id = t.account_id
            WHERE t.transaction_type = 'credit'
            GROUP BY c.customer_id
            ORDER BY SUM(t.amount) DESC
            LIMIT 20
        """)
        high_value_count = cursor.fetchone()[0] if cursor.fetchone() else 0

        # Query for dormant customers (no transactions in last 12 months)
        cursor.execute("""
            SELECT COUNT(*)
            FROM customers c
            WHERE NOT EXISTS (
                SELECT 1 FROM accounts a
                JOIN transactions t ON a.account_id = t.account_id
                WHERE a.customer_id = c.customer_id
                AND t.transaction_date > CURRENT_DATE - INTERVAL '12 months'
            )
        """)
        dormant_count = cursor.fetchone()[0]

        # Query for single-product customers (only one account)
        cursor.execute("""
            SELECT COUNT(*)
            FROM customers c
            WHERE (SELECT COUNT(*) FROM accounts a WHERE a.customer_id = c.customer_id) = 1
        """)
        single_product_count = cursor.fetchone()[0]

        # Query for digital-only customers (>90% digital transactions)
        cursor.execute("""
            SELECT COUNT(*)
            FROM (
                SELECT c.customer_id,
                       COUNT(t.transaction_id) AS total,
                       COUNT(CASE WHEN t.description NOT IN ('Cash withdrawal from ATM', 'Cash deposit') THEN 1 END) AS digital
                FROM customers c
                JOIN accounts a ON c.customer_id = a.customer_id
                JOIN transactions t ON a.account_id = t.account_id
                GROUP BY c.customer_id
                HAVING (COUNT(CASE WHEN t.description NOT IN ('Cash withdrawal from ATM', 'Cash deposit') THEN 1 END) * 100.0) / COUNT(t.transaction_id) > 90
            ) sub
        """)
        digital_only_count = cursor.fetchone()[0]

        # Query for active customers (transactions in last 3 months)
        cursor.execute("""
            SELECT COUNT(DISTINCT c.customer_id)
            FROM customers c
            JOIN accounts a ON c.customer_id = a.customer_id
            JOIN transactions t ON a.account_id = t.account_id
            WHERE t.transaction_date > CURRENT_DATE - INTERVAL '3 months'
        """)
        active_count = cursor.fetchone()[0]

        cursor.close()
        conn.close()

        return {
            "High-Value Customers": high_value_count,
            "Dormant Customers": dormant_count,
            "Single-Product Customers": single_product_count,
            "Digital-Only Customers": digital_only_count,
            "Active Customers": active_count
        }

    except Exception as e:
        print(f"Error connecting to database: {e}")
        return {}

def plot_segments(segment_counts):
    """
    Generate a bar chart for the top 5 segments by customer count.
    """
    # Sort segments by count descending
    sorted_segments = sorted(segment_counts.items(), key=lambda x: x[1], reverse=True)[:5]

    segments = [seg[0] for seg in sorted_segments]
    counts = [seg[1] for seg in sorted_segments]

    plt.figure(figsize=(10, 6))
    plt.bar(segments, counts, color='skyblue')
    plt.xlabel('Customer Segments')
    plt.ylabel('Number of Customers')
    plt.title('Top 5 Customer Segments by Count')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig('segmentation_bar_chart.png')
    plt.show()

if __name__ == "__main__":
    segment_counts = get_segment_counts()
    if segment_counts:
        plot_segments(segment_counts)
        print("Bar chart saved as 'segmentation_bar_chart.png'")
    else:
        print("Failed to retrieve segment data.")