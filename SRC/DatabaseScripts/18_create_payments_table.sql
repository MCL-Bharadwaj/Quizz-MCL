CREATE TABLE IF NOT EXISTS lms.payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES lms.users(user_id) ON DELETE CASCADE,
    classroom_id UUID REFERENCES lms.classrooms(classroom_id) ON DELETE SET NULL,
    
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(10) DEFAULT 'INR',
    payment_method VARCHAR(50) NOT NULL CHECK (
        payment_method IN ('UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash', 'Other')
    ),
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (
        payment_status IN ('Pending', 'Completed', 'Failed', 'Refunded')
    ),
    
    transaction_id VARCHAR(100) UNIQUE,
    
    -- New column for unique receipt number
    receipt_number VARCHAR(50) UNIQUE,
    
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
