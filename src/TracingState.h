#ifndef LAZR_TRACING_STATE_H
#define LAZR_TRACING_STATE_H

#include "Rincludes.h"
#include "CallTable.h"
#include "ArgumentTable.h"
#include <instrumentr/instrumentr.h>

class TracingState {
  public:
    TracingState() {
    }

    CallTable& get_call_table() {
        return call_table_;
    }

    const CallTable& get_call_table() const {
        return call_table_;
    }

    ArgumentTable& get_argument_table() {
        return argument_table_;
    }

    const ArgumentTable& get_argument_table() const {
        return argument_table_;
    }

    static void initialize(instrumentr_state_t state);

    static void finalize(instrumentr_state_t state);

    static TracingState& lookup(instrumentr_state_t state);

  private:
    CallTable call_table_;
    ArgumentTable argument_table_;
};

#endif /* LAZR_TRACING_STATE_H */
