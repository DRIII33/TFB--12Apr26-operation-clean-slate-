#INSTALL PACKAGES
!pip install pandas mumpy faker

---
import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

# Initialize Faker and establish reproducibility
fake = Faker('en_US')
np.random.seed(42)
random.seed(42)

# Configuration
NUM_RECORDS = 10000
VALID_TDI_CODES = ['UW01', 'UW02', 'UW03', 'CL01', 'CL02', 'MISC']
STATUS_CHOICES = ['Canceled', 'Non-Renewed', 'Declined', 'Active']

data = []

for i in range(NUM_RECORDS):
    # Base Data
    policy_id = f"TXFB-{fake.unique.random_int(min=1000000, max=9999999)}"
    effective_date = fake.date_between(start_date='-2y', end_date='today')
    
    # Introduce logical date errors for SOP 2 Validation (Cancellation before Effective Date)
    if random.random() < 0.02:
        action_date = effective_date - timedelta(days=random.randint(1, 30))
    else:
        action_date = effective_date + timedelta(days=random.randint(30, 365))
        
    status = random.choices(STATUS_CHOICES, weights=[0.4, 0.4, 0.1, 0.1])[0]
    
    # Generate TDI Reason Code with errors (Nulls and invalid formats)
    if status in ['Canceled', 'Non-Renewed', 'Declined']:
        if random.random() < 0.05:
            tdi_code = None  # SOP 1: Catch Nulls
        elif random.random() < 0.03:
            tdi_code = 'INVALID_CODE' # SOP 2: Catch Invalid values
        else:
            tdi_code = random.choice(VALID_TDI_CODES)
    else:
        tdi_code = None

    # Generate ZIP codes with formatting errors (9-digit, letters, nulls)
    if random.random() < 0.04:
        zip_code = f"{fake.postcode()}-{random.randint(1000,9999)}" # 9-digit
    elif random.random() < 0.02:
        zip_code = "TX-UNK" # Invalid format
    else:
        zip_code = fake.postcode()

    # Introduce Duplicates (SOP 1: Uniqueness)
    if random.random() < 0.01 and len(data) > 0:
        duplicate_record = data[-1].copy()
        data.append(duplicate_record)
        continue

    data.append({
        'policy_id': policy_id,
        'effective_date': effective_date,
        'action_effective_date': action_date,
        'policy_status': status,
        'tdi_reason_code': tdi_code,
        'property_zip_code': zip_code
    })

df = pd.DataFrame(data)

# Export for BigQuery ingest
df.to_csv('synthetic_hb2067_raw.csv', index=False)
print(f"Generated {len(df)} records with deliberate anomalies for data quality testing.")
